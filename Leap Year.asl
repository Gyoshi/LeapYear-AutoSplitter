state("Leap Year")
{
    int scene : 0xD6FF54;
    int dates : 0xD6FE98, 0xB18, 0x430, 0x0, 0x178; // counts down from 29 for each date collected
    double timer : 0xD7F450, 0xB0, 0x190, 0x50;
}

startup
{
    settings.Add("Every 4th",  false, "Split only on every 4th date collected (and also on the 29th)");   
}

start
{
    // Start when going from main menu scene to in-game scene. Also checks whether the dates is set to 29 to distinguish New Game from Continue. (false positive when continuing a game that has not collected any dates)
    return old.scene == 2 && current.scene == 3 && current.dates == 29;
}

split
{
    if (current.dates != old.dates-1)
    {
        return false;
    }
    if (settings["Every 4th"])
    {
        return current.dates == 0 || (29-current.dates) % 4 == 0;
    }
    else
    {
        return true;
    }
}

gameTime
{
	return TimeSpan.FromSeconds(current.timer);
}

isLoading
{
    return true;
}