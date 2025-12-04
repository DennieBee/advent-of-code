var part2 = true;
var cursor = 50;
var zeros = 0;
var input = File.OpenText("day01.input").ReadToEnd();
var lines = input.Split("\n");

foreach (var line in lines)
{
    var amount = Convert.ToInt32(line.Substring(1));
    var inc = 1;
    if (line.StartsWith("L")) inc = -1;

    for (int i = 0; i < amount; i++)
    {
        cursor += inc;
        if (cursor == -1) cursor = 99;
        if (cursor == 100) cursor = 0;
        if (part2) if (cursor == 0) zeros++;
    }
    if (!part2) if (cursor == 0) zeros++;
}

Console.WriteLine(zeros);