# ft-da-smol
Repo for fine-tuning af SmolLM2-1.7B

Manual training:
axolotl train configs/large.yml

Environment variables for logging:
- WANDB_MODE: Set to "online" to enable Weights & Biases logging (default: "disabled")
- MLFLOW_MODE: Set to "enabled" to enable MLflow logging (default: "disabled")
  - MLFLOW_TRACKING_URI: MLflow tracking server URI (required if MLflow enabled)
- COMET_MODE: Set to "online" to enable Comet logging (default: "disabled")
  - COMET_API_KEY: Comet API key (required if Comet enabled)
- LOG_LEVEL: Set logging detail level (default: "info", options: debug, info, warning, error)
- USE_CODECARBON: Set to "true" to track energy consumption and CO2 emissions (default: "false")

Local logging:
- Training metrics are automatically saved to CSV files in the output directory
- Detailed logs are saved to logs/training_<timestamp>.log
- Console output is mirrored to the log file
- Training state and checkpoints are saved in the output directory specified in your config
- If CodeCarbon is enabled, emissions data is saved to logs/emissions_<timestamp>.csv

For troubleshooting and advanced options:
https://github.com/axolotl-ai-cloud/axolotl
