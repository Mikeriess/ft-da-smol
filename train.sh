#!/bin/bash

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Check if config file exists
if [ ! -f "configs/large.yml" ]; then
    echo "Error: configs/large.yml not found"
    exit 1
fi

# Check if CUDA is available
if ! command -v nvcc &> /dev/null; then
    echo "Error: CUDA is required but not installed"
    exit 1
fi

# Create logs directory if it doesn't exist
mkdir -p logs

# Optional arguments with defaults
WANDB_MODE=${WANDB_MODE:-"disabled"}     # wandb logging: "online" or "disabled"
MLFLOW_MODE=${MLFLOW_MODE:-"disabled"}   # mlflow logging: "enabled" or "disabled"
COMET_MODE=${COMET_MODE:-"disabled"}     # comet logging: "online" or "disabled"
LOG_LEVEL=${LOG_LEVEL:-"info"}           # Logging level: debug, info, warning, error
USE_CODECARBON=${USE_CODECARBON:-"false"} # Enable CodeCarbon tracking
DEEPSPEED_ARGS="--deepspeed deepspeed_configs/zero2.json"

# Generate timestamp for log files
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/training_${TIMESTAMP}.log"
EMISSIONS_FILE="logs/emissions_${TIMESTAMP}.csv"

# Export environment variables
export WANDB_MODE=$WANDB_MODE
export MLFLOW_TRACKING_URI=${MLFLOW_TRACKING_URI:-""}
export COMET_API_KEY=${COMET_API_KEY:-""}

# Install CodeCarbon if enabled
if [ "$USE_CODECARBON" = "true" ]; then
    pip install codecarbon
    export CODECARBON_LOG_FILE=$EMISSIONS_FILE
fi

echo "Starting training with Axolotl..."
echo "Using config: configs/large.yml"
echo "Logging modes:"
echo "- Wandb: $WANDB_MODE"
echo "- MLflow: $MLFLOW_MODE"
echo "- Comet: $COMET_MODE"
echo "- Local log file: $LOG_FILE"
echo "- CodeCarbon: $USE_CODECARBON (output: $EMISSIONS_FILE)"

# Add logging arguments
LOGGING_ARGS=""
if [ "$MLFLOW_MODE" = "enabled" ]; then
    LOGGING_ARGS="$LOGGING_ARGS --use_mlflow"
fi

# Start training with logging to both console and file
{
    echo "=== Training started at $(date) ==="
    if [ "$USE_CODECARBON" = "true" ]; then
        codecarbon-wrapper axolotl train configs/large.yml $DEEPSPEED_ARGS $LOGGING_ARGS \
            --log_level $LOG_LEVEL \
            --log_file $LOG_FILE 2>&1
    else
        axolotl train configs/large.yml $DEEPSPEED_ARGS $LOGGING_ARGS \
            --log_level $LOG_LEVEL \
            --log_file $LOG_FILE 2>&1
    fi
} | tee -a $LOG_FILE 