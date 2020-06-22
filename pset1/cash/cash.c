#include<stdio.h>
#include<math.h>
#include<cs50.h>

int main(void)
{
    float dollars;
    int coins = 0;

    do
    {
        dollars = get_float("Enter your money owned: "); //Getting the float value from the user
    }
    while (dollars < 0); //Condition for having only positive integers as choice

    int cents = round(dollars * 100); //As stated by CS50

    coins += cents / 25;
    cents %= 25;                    //We use modulo operater per denominations available for us to work with the remaining coins

    coins += cents / 10;
    cents %= 10;

    coins += cents / 5;
    cents %= 5;

    coins += cents / 1;
    cents %= 1;

    printf("%i", coins);            // Printing the money owned

}