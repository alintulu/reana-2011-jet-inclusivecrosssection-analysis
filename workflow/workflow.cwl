#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.data_1)
      - $(inputs.settings)
      - $(inputs.normalize)

inputs:
  data_1:
    type: File
  settings:
    type: File
  normalize:
    type: File

outputs:
  output-DATA-2a.root:
    type: File
    outputSource:
      normalizeHistosData/output-DATA-2a

steps:
  normalizeHistosData:
    run: normalizeHistosData.cwl
    in:
      settings: settings
      normalize: normalize
      data_1: data_1
    out: [output-DATA-2a]

