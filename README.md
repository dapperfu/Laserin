# Laserin

Automated CI/CD pipeline for converting SVG files to G-code using the [laser-tool](https://github.com/dapperfu/laser-tool) Python module. This project automatically processes SVG files and generates G-code files optimized for laser cutting and engraving operations.

## Overview

Laserin provides a GitHub Actions workflow that automatically converts SVG files to G-code whenever changes are pushed to the repository. The generated G-code files are uploaded as artifacts, making them easily accessible for download and use with laser cutting machines.

## Features

- **Automated Processing**: Automatically processes all SVG files in the repository on every push
- **Combined Operations**: Generates combined G-code files that handle both engraving and cutting operations
- **Artifact Storage**: Uploads generated G-code files as GitHub Actions artifacts with 30-day retention
- **Layer Support**: Processes "engrave" and "cut" layers from SVG files with optimized settings
- **Local Development**: Includes Makefile targets for local testing and development

## Prerequisites

- **Python 3.10+**: Required for running the laser-tool module
- **GitHub Actions**: Enabled for your repository (enabled by default)
- **SVG Files**: SVG files with properly named layers ("engrave" and "cut") for best results

## Installation

### For Local Development

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd Laserin
   ```

2. Install dependencies:
   ```bash
   make build
   ```

   Or manually:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

## Usage

### GitHub Actions Workflow

The workflow automatically runs on every push to any branch:

1. **Add SVG Files**: Place your SVG files anywhere in the repository (root or subdirectories)
2. **Push Changes**: Push your changes to trigger the workflow
3. **Download Artifacts**: After the workflow completes, download the `gcode-files` artifact from the Actions tab

#### Workflow Settings

The workflow uses the following default settings:

- **Engraving**: Speed 1000 units/min, Power 75 (M3 S75)
- **Cutting**: Speed 250 units/min, Power 255 (M3 S255)
- **Travel Speed**: 3000 units/min

These settings are optimized for typical laser cutting operations but can be customized by editing `.github/workflows/generate-gcode.yml`.

### Local Development

#### Generate G-code Locally

Process all SVG files in the repository:

```bash
make run
```

This will:
- Create a virtual environment if it doesn't exist
- Install dependencies
- Process all SVG files found in the repository
- Generate `{filename}_combined.gcode` files

#### Clean Generated Files

Remove all generated G-code files and Python cache:

```bash
make clean
```

#### Validate Setup

Test that the laser-tool is installed correctly:

```bash
make test
```

#### View Available Commands

```bash
make help
```

### SVG File Requirements

For best results, your SVG files should:

1. **Use Proper Layer Names**: Name layers "engrave" and "cut" for automatic processing
2. **Convert Objects to Paths**: Ensure all shapes are converted to paths (Inkscape: Path > Object to Path)
3. **Set Document Units**: Use millimeters (mm) or inches (in) as document units
4. **Proper Scaling**: Set Scale x and Scale y to 1 in Document Properties

The workflow processes all SVG files found in the repository, regardless of layer names. Files without "engrave" or "cut" layers will still be processed but may not produce optimal results.

## Project Structure

```
Laserin/
├── .github/
│   └── workflows/
│       └── generate-gcode.yml    # GitHub Actions workflow
├── .gitignore                    # Git ignore patterns
├── Makefile                      # Build and development targets
├── requirements.txt              # Python dependencies
├── README.md                     # This file
├── LICENSE                       # License file
└── *.svg                         # Your SVG source files
```

## Configuration

### Customizing Workflow Settings

Edit `.github/workflows/generate-gcode.yml` to customize:

- **Engraving Settings**: `--engrave-cutting-speed` and `--engrave-power`
- **Cutting Settings**: `--cut-cutting-speed` and `--cut-power`
- **Travel Speed**: `--travel-speed`
- **Python Version**: Change `python-version` in the setup-python step
- **Artifact Retention**: Modify `retention-days` in the upload-artifact step

### Example Customization

```yaml
python -m laser.combine_cut_engrave "$svg" \
  --engrave-cutting-speed 1500 \    # Faster engraving
  --engrave-power 50 \               # Lower power
  --cut-cutting-speed 200 \          # Slower cutting
  --cut-power 255 \                  # Full power
  --travel-speed 5000 \              # Faster travel
  -o "$output"
```

## Examples

### Workflow Output

When you push SVG files, the workflow will:

1. Find all `.svg` files in the repository
2. Process each file to generate `{filename}_combined.gcode`
3. Upload all G-code files as a single artifact named `gcode-files`

Example output files:
- `sample.svg` → `sample_combined.gcode`
- `EngraveCut.svg` → `EngraveCut_combined.gcode`
- `demo_layers.svg` → `demo_layers_combined.gcode`

### Downloading Artifacts

1. Go to the **Actions** tab in your GitHub repository
2. Click on the latest workflow run
3. Scroll down to the **Artifacts** section
4. Click **gcode-files** to download the ZIP archive
5. Extract the ZIP to access your G-code files

## Troubleshooting

### Workflow Fails

- **Check SVG Files**: Ensure SVG files are valid and properly formatted
- **Check Layer Names**: Verify that layers are named correctly ("engrave", "cut")
- **Check Workflow Logs**: Review the Actions logs for specific error messages

### No G-code Files Generated

- **Check SVG Content**: Ensure SVG files contain paths (not just shapes)
- **Check Layer Structure**: Verify layers exist and are properly named
- **Check Workflow Logs**: Look for warnings or errors in the workflow output

### Local Generation Issues

- **Virtual Environment**: Ensure virtual environment is activated
- **Dependencies**: Run `make build` to install dependencies
- **Python Version**: Verify Python 3.10+ is installed (`python3 --version`)

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally using `make test` and `make run`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [laser-tool](https://github.com/dapperfu/laser-tool) - The Python module used for SVG to G-code conversion
- [J-Tech Photonics Laser Tool](https://github.com/JTechPhotonics/J-Tech-Photonics-Laser-Tool) - Original laser tool project

## Related Resources

- [laser-tool Documentation](https://github.com/dapperfu/laser-tool)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Inkscape Documentation](https://inkscape.org/learn/)
