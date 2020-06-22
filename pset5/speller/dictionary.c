//Implementing Dictionary
//Code by Yash 'typ1cal' Wadhawe

#include <stdbool.h>
#include "dictionary.h"

#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define HASHTABLE_SIZE 1000
//Creating a node |L I N K E D  L I S T|
typedef struct node
{
    char word [LENGTH + 1];
    struct node *next;
}
node;


node *hashtable[HASHTABLE_SIZE]; //Generating Hashtable SIZE

unsigned int num_words = 0;     //Funtions below
bool is_loaded_dict;

unsigned int hash(const char *word)     //Hash
{
    int hash = 0;
    int n;
    for (int i = 0; word[i] != '\0'; i++)
    {
        if (isalpha(word[i]))
        {
            n = word[i] - 'a' + 1;
        }
        else
        {
            n = 27;
        }
        hash = ((hash << 3) + n) % HASHTABLE_SIZE;
    }
    return hash;
}

bool check(const char *word)    //To check characters of the string
{
    char check_word[strlen(word)];
    strcpy(check_word, word);
    for (int i = 0; check_word[i] != '\0'; i++)
    {
        check_word[i] = tolower(check_word[i]);
    }
    int index = hash(check_word);
    if (hashtable[index] != NULL)
    {
        for (node *nodeptr = hashtable[index]; nodeptr != NULL; nodeptr = nodeptr -> next)
        {
            if (strcmp(nodeptr->word, check_word) == 0)
            {
                return true;
            }
        }
    }
    return false;
}


bool load(const char *dictionary) //Loading dictionary
{
    FILE *infile = fopen(dictionary, "r");
    if (infile == NULL)
    {
        return false;
    }
    for (int i = 0; i < HASHTABLE_SIZE; i++)
    {
        hashtable[i] = NULL;
    }

    char word[LENGTH + 1];
    node *new_nodeptr;
    while (fscanf(infile, "%s", word) != EOF)
    {
        num_words++;
        do
        {
            new_nodeptr = malloc(sizeof(node));
            if (new_nodeptr == NULL)
            {
                free(new_nodeptr);
            }
        }
        while (new_nodeptr == NULL);


        strcpy(new_nodeptr -> word, word);      //To copy string
        int index = hash(word);
        new_nodeptr -> next = hashtable[index];
        hashtable[index] = new_nodeptr;
    }
    fclose(infile);
    is_loaded_dict = true;
    return true;
}

unsigned int size(void)     //To check if string is loaded or not
{
    if (!is_loaded_dict)
    {
        return 0;
    }
    return num_words;
}


bool unload(void)   //Unloading Dictionary
{
    if (!is_loaded_dict)
    {
        return false;
    }

    for (int i = 0; i < HASHTABLE_SIZE; i++)
    {
        if (hashtable[i] != NULL)
        {
            node *ptr = hashtable[i];
            while (ptr != NULL)
            {
                node *predptr = ptr;
                ptr = ptr -> next;
                free(predptr);
            }
        }
    }
    return true;
}


//End of the code
//This is CS50