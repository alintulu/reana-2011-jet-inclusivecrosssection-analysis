cwlVersion: v1.0
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull:
      clelange/cmssw:9_4_4
  InitialWorkDirRequirement:
    listing:
      - $(inputs.settings)
      - $(inputs.combine)
      - $(inputs.data_2a)

inputs:
  settings:
    type: File
  combine:
    type: File
  data_type:
    type: string
    default: DATA
  data_2a:
    type: File
  outfile:
    type: string
    default: output-DATA-2b.root

baseCommand: /bin/sh

arguments:
  - prefix: -c
    valueFrom: |
      root -l -b -q '$(inputs.combine.basename)("$(inputs.data_type)")'

outputs:
  output-DATA-2b:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
