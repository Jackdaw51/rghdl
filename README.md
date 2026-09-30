# rghdl
An improved version of ghdl written in rust
### Basic workflow explained
The file is read char by char; the **lexer** tokenizes it in **Tokens**, ``Token{Tokenkind}``.\
The **parser** then builds the Abstract Syntax Tree, ``AstArena``, which is a collection of vectors containing the structures. \
Already here lexical rules are imposed, on error they are pushed into the error vector and the parsing goes on.\
Then comes the **Semantic analyzer**, it has to figure out every Symbol meaning and enforce rules like correct assignment to correct type.\
In the same fashion as the parser, when an error is incurred into, it gets pushed into the error vector and semantic analysis goes on. 

# How to expand the language
### To see that, I'll implement the generate statements here with you, as a guide
##### Standard
First thing first, learn what is a `generate`. \
Then refer to the standard to see what are the possible cases encountered.
We can see that many kinds of generate block can exist, we'll limit ourselves for now to implementing support for the *for generate* and the *if generate* clause.
##### Lexing
So we start from the bottom (**lexer**). We need to add the new keywords that we still didn't add, that consist of a `TokenKind::*keyword*` and a `&str` correspondence (importantly, in lowercase); at this point of the project they are `for` and `generate`. All around the project there may be some matches on those value (e.g. for printing), the compiler will guide you towards implementing the missing parts. 
##### Parsing
We need to create the structure in the AST encoding the new statement(s). From the standard we know that `generate` blocks are *concurrent statements*, thus we have to implement a `ConcurrentStmt` enum variant.
I chose to have two different variants for the 2 types of `generate` blocks to keep everything small and modular.
`ForGenerate` and `IfGenerate`. At this point we need to pause and ponder on what the enum will have to contain. From the standard we know that both have a non-optional label, thus a `SymbolId`. \
In the case o the `ForGenerate`, we'll have to encode a symbol for the iterator (`SymbolId`), the expression for ranging left and ranging right (`ExprId`s), the direction (`TokenKind` because it could be `downto` or `to`), and the range of statements, encoding the body (in rghdl when we have a list of statements, we use a `Range<u32>` to slice into the corresponding list in the ast). \
For the `IfGenerate` instead, we'll only need the condition expression (`ExprId`) and the statements body (`Range<u32>`). We'll limit ourselves to this kind of `IfGenerate`, without `else` and `ifelse` blocks, compliant to an older standard,  VHDL-93, for simplicity.

We now have to implement the actual logic. We start by looking into the `parse` functions and soon find ourselves into the `parse_concurrent_statement` function. The details of the implementation are left out of this guide, but remember that there are a lot of helper function to write idiomatic code. For inspiration, refer to the other functions.
Remember to enforce syntax using `self.expect()`.
##### Semantic analysis
We need to enforce semantic rules over our newly constructed `generate` block. 
Our starting point will be to add two branches into `check_concurrent_stmt()`.
Let's start from the `For`:
We create a new scope representing the block, to isolate all the newly created variables (e.g. iterator).
Let's declare the iterator in the scope. We need to know what type it is; from the standard:

*For a for generate statement, the generate parameter specification is the declaration of the generate parameter with the given identifier. The generate parameter is a constant object whose type is the base type of the discrete range of the generate parameter specification.* 

Meaning that if there is an integer and a derived type (like `positive`) we enforce the type of the iterator to be the base type, i.e. integer.
I never actually dealt with implicit declarations, so we need to account for that, adding an enum variant to `DeclRef` that I will call `Implicit(TypeId)`. Also a `DeclRef` for the generate block, that will contain the block scope_id.
We assert the type from left and right expression resolves to integer base and then we assign the type integer it to the implicit declaration `iterator`. Lastly, we recursively check for the concurrent statements in the body.

For the `IfGenerate` instead, the thing is simpler. Just add the label, evaluate the condition to boolean and recursively check the body.







