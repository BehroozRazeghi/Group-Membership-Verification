# Group Membership Verification via Nonlinear Sparsifying Transform Learning


## File Descriptions
- `AUC.m`: Computes the Area Under the Curve (AUC) for model evaluation.
- `ComputeScores.m`: Calculates scores using predefined weights, transformations, and parameters.
- `NLTransRepLearn.m`: Main function to learn nonlinear transformative representations.
- `Perf_NLTR.m`: Evaluates performance metrics for identification and verification processes.
- `PosNeg.m`: Utility function to adjust matrix elements based on positivity or negativity.
- `UnitNorm.m`: Normalizes matrices to unit length.
- `UpdateTheta.m`: Updates parameters theta based on the current state.
- `UpdateW.m`: Adjusts transformation matrix W as per optimization algorithms.
- `UpdateY.m`: Updates representations and group assignments.
- `partition.m`: Partitions data into clusters based on specified methods.
- `test_CFP.m` & `test_LFW.m`: Scripts to test the framework on CFP and LFW datasets respectively.

## Installation

### Prerequisites
- MATLAB R2019b or later
- Statistics and Machine Learning Toolbox

### Setup
Clone this repository to your local machine using:
```bash
git clone https://github.com/BehroozRazeghi/Group-Membership-Verification.git
cd Group-Membership-Verification
```

## Usage
To use the GMV-NSTL framework, perform tests on your datasets using the provided scripts. 
Here’s how to run these tests in MATLAB:
```bash
run('test_CFP.m');  # For testing on the CFP dataset
run('test_LFW.m');  # For testing on the LFW dataset
```
