#!/usr/bin/env python3
import os
from transformers import T5EncoderModel, T5Tokenizer

# Create directory for ProtTrans models (this is what TemStaPro expects)
model_dir = "./ProtTrans"
os.makedirs(model_dir, exist_ok=True)

# TemStaPro uses this model identifier (from their source code)
model_name = "Rostlab/prot_t5_xl_uniref50"

print(f"Downloading ProtTrans model: {model_name}")
print("This may take 10-20 minutes depending on your connection...")

# Download and save model (exactly as TemStaPro does it)
print("📥 Downloading model...")
model = T5EncoderModel.from_pretrained(model_name)
model.save_pretrained(model_dir)

print("📥 Downloading tokenizer...")
tokenizer = T5Tokenizer.from_pretrained(model_name, do_lower_case=False)
tokenizer.save_pretrained(model_dir)

print(f"✅ Model downloaded successfully to: {os.path.abspath(model_dir)}")

# Verify the expected files are present
expected_files = ['pytorch_model.bin', 'config.json', 'tokenizer_config.json']
print("\n📁 Checking required files:")
for file in expected_files:
    if os.path.exists(os.path.join(model_dir, file)):
        print(f"  ✅ {file}")
    else:
        print(f"  ❌ {file} - MISSING!")

print(f"\n🎯 Use this path with TemStaPro: {os.path.abspath(model_dir)}")