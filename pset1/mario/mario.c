#include<stdio.h>
#include<cs50.h>

int main(void)
{
    //Declaring necessary variables
    int n = 0;
    int i = 0, j = 0;
    do
    {
        n = get_int("Height: ");
    }
    while (n <= 0 || n >= 9); //Condtition for height to be in range 1 to 8


    for (i = 1; i <= n; i++)
    {
        for (j = 1; j <= n; j++)
        {
            if (j >= n + 1 - i)
            {
                printf("#"); //Will print # n+1-i th position
            }
            else
            {
                printf(" "); //Spaces
            }
        }
        printf("\n"); //Obviously a new line for better looking code
    }


}
