#include <stdio.h>
#include <cs50.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

bool check_key(string s); // As what david tells to do




int main(int argc, string argv[])
{
    if (argc != 2 || !check_key(argv[1]))
    {
        printf("Usage: ./caesar key\n");  //For incorrent argument entry
        return 1;
    }
    int key = atoi(argv[1]); //To convert string to interger


    string plaintext = get_string("plaintext: ");

    printf("ciphertext: "); //We get our ciphertext to be implemented
    for (int i = 0, len = strlen(plaintext); i < len; i++)
    {
        char c = plaintext[i];
        if (isalpha(c))
        {
            char m = 'A';
            if (islower(c))
            {
                m = 'a';
            }
            printf("%c", (c - m + key) % 26 + m);
        }
        else
        {
            printf("%c", c);
        }
    }
    printf("\n");
}

bool check_key(string s) // Check string funtion
{
    for (int i = 0, len = strlen(s); i < len; i++)
    {
        if (!isdigit(s[i]))
        {
            return false;
        }
    }
    return true;
}