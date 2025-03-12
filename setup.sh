pip3 install --no-build-isolation axolotl[flash-attn,deepspeed]

# Fetch example configs
echo "Fetching example configs..."
axolotl fetch examples
axolotl fetch deepspeed_configs

echo "Setup complete!"
echo "Start training: axolotl train configs/large.yml" 