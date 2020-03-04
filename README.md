# Cortex examples

## Setup

### 1. Download Examples

- Option 1. From zip file: Unzip `cortex-examples.zip` into the current working directory:
```bash
  $ unzip <path/to/cortex-examples.zip>
```
- Option 2. From source:
```bash
  $ git clone git@github.com:CognitiveScale/cortex-examples.git
```
 
### 2. Setup Conda Environment with Necessary Dependencies

1. Deactivate all conda envionments (run this command as many times as needed until no conda environments are active)
```bash
  $ conda deactivate
```
2. (Re)Create a clean conda env
```bash
  $ conda env remove -n cortex-examples || true
  $ conda create -n cortex-examples python=3.6.10 pip -y
```
3. Install necessary deps in env
```bash
  $ conda activate cortex-examples
  $ pip install -r requirements-dev.txt
```
4. Reactivate conda env & ensure proper binaries are being used
```bash
  $ conda deactivate; conda activate cortex-examples
  $ (which jupyter | grep 'cortex-examples/bin/jupyter') || echo "ERROR: Using wrong jupyter binary."
```

## Cortex Hello World example

### Running the Hello World example

1. From the left-side menu, open `notebooks/skills/hello_world.ipynb`
2. Run the file.


## Cortex Ames Realestate example

### Running the Ames example

1. From the left-side menu, open the `notebooks/ames-housing/ames_*.ipynb` files.
2. Run the files in the following order:
  1. `ames_analysis.ipynb`
  2. `ames_clean.ipynb`
  3. `ames_features.ipynb`
  4. `ames_modeling.ipynb`
  5. `ames_deploy.ipynb`

