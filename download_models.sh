[ -f assets/models/qwen_small.gguf] || wget https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q2_k.gguf?download=true -O assets/models/qwen_small.gguf
[ -f assets/models/embed.onnx] || wget https://github.com/Telosnex/fonnx/raw/refs/heads/main/example/assets/models/miniLmL6V2/miniLmL6V2.onnx?download=true -O assets/models/embed.onnx
