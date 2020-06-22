#include<stdio.h>
#include<string.h>
#include<cs50.h>
#include<ctype.h>
#include<math.h>


int main(void)
{
    int letter = 0;         // Letter count
    int words = 0;          // Word count
    int sentence = 0;       // Sentence count

    string text = get_string("Text: ");
    for (int i = 0, len = strlen(text); i < len; i++)
    {
        if (isalpha(text[i]))  // Using ctype as suggested by Prof.
        {
            letter++; //Incrementing Letter count
        }
        if ((i == 0 && text[i] != ' ')
            || (i != len - 1 && text[i] == ' ' && text[i + 1] != ' ')) //satisfies all condition for a string to be a word
        {
            words++; // Incrementing word count
        }
        if (text[i] == '.' || text[i] == '?' || text[i] == '!')
        {
            sentence++; // Sentence count
        }
    }
    float L = (letter / (float) words) * 100;
    float S = (sentence / (float) words) * 100;
    int index = round(0.0588 * L - 0.296 * S - 15.8);

    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %i\n", index);
    }

}