# reana-2011-jet-inclusivecrosssection-analysis

## Analysis structure

**1. Input Data**

In this example the input data is read from eospublic.cern.ch//eos/opendata in the first step of the workflow. The input data is in the format of CMS AOD root files. There are two root files, one containing ntuples of detected data and the other ntuples of simulated Monte Carlo data.

**2. Analysis Code**

This example uses the [ROOT](https://root.cern.ch/) analysis framework with the custom user code located in the `code` directory.

- A pure ROOT6 container image is used for most steps, this analysis needs no specific tools. The five steps of the analysis are:

  1. FillHistos

    The first part of the code reads the input root files and fills appropriate histograms. The histograms get categorized according to (1) eta intervall and (2) the trigger that triggered the detection.
  
  2. NormalizeHistos
  
    This part of the analysis normalizes the histograms with the following command:
  
    ```
    for int i from 1 to hpt->GetNbinsX()+1
      double norm = hpt->GetBinWidth(i) * etawid * hlumi->GetBinContent(i);
      hpt->SetBinContent(i, hpt->GetBinContent(i) / norm);
      hpt->SetBinError(i, hpt->GetBinError(i) / norm);
    ```
   
  3. CombineHistos
  
    Combine the histograms that are detected with different triggers but within the same eta width. Every trigger is the most efficent within different pt ranges. Use the detected events within a certain pt range from the trigger who have the    largest effectivness within that range.
    
  4. Theory
  
    Here the data gets fitted to a theory curve, a NLO curve. The curves can be found at 
    
    ```
    http://www-ekp.physik.uni-karlsruhe.de/~rabbertz/fastNLO_LHC/InclusiveJets/
    -> fnl2342_cteq66_aspdf_full.root
    Numbering scheme explained in
    https://twiki.cern.ch/twiki/bin/view/CMS/CMSfastNLO
    2-point to 6-point theory uncertainty:
    h200X00->h300X09, h400X00->h300X08 
    ```
    
  5. Dagostini
  
    Last step is unfolding of the data. The method used is called d'Agostini ("Baysian" or Richardson-Lucy) unfolding and the code includes a response matrix generation from NLO theory and parameterized JER.
    
    
 **3. Compute environment**
 
In order to be able to rerun the analysis even several years in the future, we
need to "encapsulate the current compute environment", for example to freeze the
ROOT version our analysis is using. We shall achieve this by preparing a `Docker
<https://www.docker.com/>`_ container image for our analysis steps.

Some of the analysis steps will run in a pure `ROOT <https://root.cern.ch/>`_
analysis environment. We can use an already existing container image, for
example `reana-env-root6 <https://github.com/reanahub/reana-env-root6>`_, for
these steps.

**4. Analysis workflow**

```
  +-----------+             +-------+
  | Fill data |             |Fill MC|   
  +-----------+             +-------+  
       |                       |
       |                       |        
       v                       v  
  +---------------+       +------------+
  | Normalize data|       |Normalize MC|   
  +---------------+       +------------+  
       |                       |
       |                       |        
       v                       v 
  +-------------+         +----------+
  | Combine data|         |Combine MC|   
  +-------------+         +----------+  
       |                        |
       |     +------------+     |        
       +---> | Theory Data|<--- +
       |     +------------+     |
       |      +------------+    |        
       +--->  |  Theory MC |<---+
       |      +------------+    |
       |             |          |
       |             |          |
       +-------------+----------+ 
       |                        |
       v                        v
 +--------------+        +------------+
 | Dagostini Data|       |Dagostini MC|
 +--------------+        +------------+ 
       |
       |
       v
 +------------+
 | Draw plots |
 +------------+
```
