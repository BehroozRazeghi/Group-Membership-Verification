# Group Membership Verification via Nonlinear Sparsifying Transform Learning


## File Descriptions
- `AUC.m`: Computes the Area Under the Curve (AUC) for model evaluation.
- `ComputeScores.m`: Computes discriminative scores used for group assignment and verification
- `NLTransRepLearn.m`: Main function to learn nonlinear transform representations.
- `Perf_NLTR.m`: Script to evaluate performance metrics including false positive and true positive rates for both identification and verification processes across datasets.
- `PosNeg.m`: Utility function to apply positive and negative transformations.
- `UnitNorm.m`: Normalizes matrix columns to unit length.
- `UpdateTheta.m`: Updates the theta parameters (similarity and dissimilarity measures) according to the latest data representations.
- `UpdateW.m`: Updates the transform matrix W based on current estimates.
- `UpdateY.m`: Updates the representations Y and group assignments.
- `partition.m`: Partitions data into groups.
- `test_CFP.m` & `test_LFW.m`: Scripts to test the framework on CFP and LFW datasets respectively.

## Installation

### Prerequisites
- MATLAB R2019b or later
- Statistics and Machine Learning Toolbox

### Setup
Clone this repository to your local machine using:
```bash
git clone https://github.com/BehroozRazeghi/Group-Membership-Verification.git
```
Navigate to the cloned directory:
```bash
cd Group-Membership-Verification
```

## Usage
To run the GMV-NSTL framework, execute the test scripts in MATLAB for the desired dataset:
```bash
run('test_CFP.m');  # For testing on the CFP dataset
run('test_LFW.m');  # For testing on the LFW dataset
```
