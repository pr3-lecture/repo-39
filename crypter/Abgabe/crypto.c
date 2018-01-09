/*
 *  DONE: Read arguments from Commandline
 *  DONE: Exit on to few arguments
 *  DONE: read from STDIN
 *  STARTED: Makefile
 *  STARTED: Testfile
 *  DONE: Read file
 *  DONE: encrypt
 *  DONE: decrypt
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "crypto.h"
#define DEBUG 0
#define BOOL int
#define TRUE 1
#define FALSE 0
#define TEXT "This is my test String"
#define TEXTLENGTH 100
#define LOG(string) printf("%s\n",string) 

//check if Char is in allowed Characters
BOOL isCharAllowed(char c, const char* valid){
    for (size_t i = 0; i < strlen(valid); i++){
        if (c == valid[i]){
#if DEBUG
            printf("Your char is: %c, compared with: %c",c,valid[i]);
#endif
            return TRUE;
        }
    }
    return FALSE;
}

//check if Whole Input is valid
BOOL isInputAllowed(const char* input, const char* valid){
    BOOL res = FALSE;
    for (size_t i = 0; i < strlen(input); i++){
        if(isCharAllowed(input[i], valid)){
#if DEBUG
            printf("Your char is: %c, compared with: %s\n",input[i],valid);
            LOG("Valid input");
#endif
            res = TRUE;
        } else {
            res = FALSE;
        }
    }
    return res;
}

int checkKey(KEY k){

    if(strlen(k.chars) == 0){
#if DEBUG
        LOG("Key too short");
#endif
        return E_KEY_TOO_SHORT;
    }
    if(!(isInputAllowed(k.chars, KEY_CHARACTERS))){
#if DEBUG
        printf("Illegal Key\n");
#endif
        return E_KEY_ILLEGAL_CHAR;
    }
    return 0;
}

int checkMessage(const char* m){
    if(!(isInputAllowed(m, MESSAGE_CHARACTERS))){
        return E_MESSAGE_ILLEGAL_CHAR;
    }
    return 0;
}

int checkCypher(const char* c){
    if(!(isInputAllowed(c, CYPHER_CHARACTERS))){
        return E_CYPHER_ILLEGAL_CHAR;
    }
    return 0;
}

int encrypt(KEY key, const char* input, char* output){
    //int result = checkKey(key);
    //if(result){
    //    return result;
    //}
    int result = checkMessage(input);
    if(result){
        return result;
    }
    //encrypt here
#if DEBUG
    LOG("this is a test");
    int c = (char)(key.chars[0] ^ input[0]);
    printf("the XORed ouput of %c and %c is %02X\n",key.chars[0], input[0], c);
    printf("the XORed ouput of %c and %c is %c\n",key.chars[0], input[0], CYPHER_CHARACTERS[c]);
#endif
    for (size_t i = 0; i < strlen(input); i++){
        if(i >= strlen(key.chars)){
            output[i] = CYPHER_CHARACTERS[key.chars[i%strlen(key.chars)] ^ input[i]];
        } else {
            output[i] = CYPHER_CHARACTERS[key.chars[i] ^ input[i]];
        }
    }
    return result;
}

int decrypt(KEY key, const char* cypherText, char* output){
    int result = checkCypher(cypherText);
    if(result){
        return result;
    }
    //decrypt here
    
    for (size_t i = 0; i < strlen(cypherText); i++){
        if(i >= strlen(key.chars)){
            output[i] = CYPHER_CHARACTERS[key.chars[i%strlen(key.chars)] ^ cypherText[i]];
        } else {
            output[i] = CYPHER_CHARACTERS[key.chars[i] ^ cypherText[i]];
        }
    }
    return result;
    return 0;
}



int main(int argc, char* argv[]){
    int result = 0;
#if DEBUG
    printf("Argument Count is: %d\n",argc);
    printf("Arguments are:\n");
    for (int i = 0; i < argc; i++){
        printf("%s\n",argv[i]);
    }

#endif
    if (argc <= 1){
        fprintf(stderr, "ERROR, usage is: crypto KEY [FILENAME]\nPlease try again!");
        return 1;
    }
#if DEBUG
    LOG("Correct number of Arguments");
#endif
    char *input;
    KEY k;
    k.type = 1; //XOR is type 1, according to documentation
    k.chars = argv[1]; //first argument is KEY
    result = checkKey(k);
    if(result){
        printf("illegal KEY!");
        return result;
    }
        char output[TEXTLENGTH];
    //limit string to 100 bytes
    if( argc == 2 ){ //no filename
        printf("Enter Text to be encrypted\n");
        input = malloc( sizeof(char) * (TEXTLENGTH +1 ));
        scanf("%100[^\n]%*c",input);//read the next 100 bytes until newline
#if DEBUG
        printf("Text that was inputed:\n%s\n",input);
        printf("Encypting...\n");
#endif
    } else { //read file
        FILE *fp;
        long lSize;

#if DEBUG
        fp = fopen ( "text.txt" , "rb" );
        if( !fp ) perror("text.txt"),exit(1);
#else
        fp = fopen ( argv[2], "rb" );
        if (!fp) perror(argv[2]), exit(1);
#endif

        fseek( fp , 0L , SEEK_END);
        lSize = ftell( fp );
        rewind( fp );

        // allocate memory for entire content 
        input = calloc( 1, lSize+1 );
        if( !input ) fclose(fp),fputs("memory alloc fails",stderr),exit(1);

        // copy the file into the buffer 
        if( 1!=fread( input , lSize-1, 1 , fp) )
            fclose(fp),free(input),fputs("entire read fails",stderr),exit(1);


        //for(int i = 0; i < strlen(input); i++){
            //printf("%c\n",input[i]);
        //}

        fclose(fp);
        //free(buffer);


    }

    result = encrypt(k,input,output); 
    if (result){
        fprintf(stderr, "ERROR, encryption unsuccessfull, errorcode: %d", result);
        return result;
    }

    printf("%s\n",output);
#if DEBUG
    printf("Decrypting...\n");
#endif

    result = decrypt(k,output,input);
    if(result != 0){
        fprintf(stderr, "ERROR, decryption unsuccessfull, errorcode: %d", result);
        return result;
    }

    printf("%s",input);
    
    
    return 0;
}
