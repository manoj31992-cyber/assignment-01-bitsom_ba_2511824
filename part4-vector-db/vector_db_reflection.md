## Vector DB Use Case

No, a traditional keyword search would not be enough for this law firm and I'll explain why with a simple example.

Say a lawyer wants to find all termination clauses in a 500-page contract and types "termination clauses" into a keyword search. The system will look for those exact words in the document. But contracts are written in legal language and the same concept might be written as "Right of Exit", "Cessation of Agreement", or "Dissolution of Contract" in different sections. None of these contain the word "termination" so keyword search would miss them completely. On the other hand, it would also return every paragraph that happens to mention "termination" even if it's talking about terminating a warranty or a sub-clause - giving the lawyer a flood of irrelevant results.

This is where a vector database becomes really useful. The idea is that each paragraph or clause in the contracts gets converted into a list of numbers (called an embedding or vector) using a language model. This vector captures the meaning of the text, not just the words. So "Right of Exit" and "termination clause" would produce similar vectors because they mean the same thing legally, even though they use different words.

When the lawyer asks "What are the termination clauses?", that question also gets converted into a vector, and the system finds all contract paragraphs whose vectors are close to it. This is called semantic search and it finds results based on meaning rather than exact word matching.

To build this system practically, you would first split all contracts into paragraphs or clauses, run each through an embedding model like BERT or a legal-domain fine-tuned version of it, store those vectors in a vector database like Pinecone or pgvector, and then at query time convert the lawyer's question to a vector and retrieve the top matching clauses. You could then pass these to a language model to generate a clean summarized answer.

So in short - keyword search is too rigid for legal text where the same idea can be expressed in dozens of ways. A vector database solves this by understanding the actual meaning behind both the question and the contract text.
