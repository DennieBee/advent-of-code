var cursor = 50;
var zeros = 0;
var input = File.OpenText("day01.input").ReadToEnd();
var lines = input.Split("\n");

foreach (var line in lines)
{   
    var amount = Convert.ToInt32(line.Substring(1));
    
    if (amount > 100) amount -= amount - amount % 100;

    if (line.StartsWith("L")) cursor -= amount;
    else cursor +=amount;

    if (cursor < 0) cursor += 100;
    if (cursor > 99) cursor -= 100;
    
    if (cursor == 0) zeros++;
}

Console.WriteLine(zeros);