from sentence_transformers import SentenceTransformer
from tokenizers import BertWordPieceTokenizer

repo = "cl-nagoya/ruri-base"

model = SentenceTransformer(repo)
output_dir = "/tmp/models"

model.save(output_dir)

new_tokenizer = BertWordPieceTokenizer(vocab=f"{output_dir}/vocab.txt")
new_tokenizer.save(f"{output_dir}/tokenizer.json")
