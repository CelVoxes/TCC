# Talk Can Cells?

Do cells have a language? With the recent success of large language models and the vast number of curated gene pathways, we visited this fundamental question one more time. We trained a decoder-only transformer model with 120M parameters on >250,000 human pathways, and then asked the model to complete 1000 unseen pathways with 80% masking in zero-shot setting. Remarkably, this simple ready-to-use model was able to complete more than half of the pathways (660/1000) with significant overlap. Our results suggest that even relatively small transformers can capture underlying connection among genes and understand the true nature of cell language.

>> [Blog Post](https://celvox.co/blog/TCC/index.html). 

## Preparing the dataset

I have curated genesets from public resources in *.gmt* format. This is more or less what it looks like: 

| Pathway Name | Description          | Gene Symbol |
|--------------|----------------------|-------------|
| ExamplePath  | This is a description of the ExamplePath pathway. It's involved in [specific process or function]. | EXMP1       |
| AnotherPath  | Description of AnotherPath, highlighting its significance in [related biological process]. | ANTH2       |

Then, I felt like a basic filtering strategy was necessary, so in order:

1) Harmonized all gene symbols to hg38
2) Removed the genes that occurred less than 5 times in the whole dataset
3) Selected pathways with >90% mapping to human genes
4) 95% for training, 5% for test (10,000 sets) ~44,000 tokens
5) Random 1000 sets then was selected for the inference.

All of these are [here](prepare_data.ipynb).

## Training

Basically followed the recommendations of @Andrej to train karpathy/nanoGPT. Obviously, this needs improvement. I think we could train a custom model, maybe even a different architecture (GNN?) to answer follow up questions: 

- Can we translate it to plain English? lol
- Can we use this as a base model to impute single cell data? Special tokens bla bla...
- BETTER OBJECTIVE FUNCTIONs please.

## Test

1000 random unseen pathways from step 5! Now it's time to mask 80% of each and generate... brr.
Details? [Here](test.ipynb).

## Food for Thought

Isn’t funny how 2-bits seems to be natural evolution for LLMs? Like DNA which consists of 4 letters (A,T,G,C) or operates on 2-bits. In order to run an LLM, all you need is a weight matrix and a run file (e.g. [llama2.c](https://github.com/karpathy/llama2.c)), just like a DNA.

So, *what is the run.c function for DNA?* 

I think we will learn the answer soon. 

[![](https://dcbadge.vercel.app/api/server/X7strFxxkz?compact=true&style=flat)](https://discord.gg/X7strFxxkz)