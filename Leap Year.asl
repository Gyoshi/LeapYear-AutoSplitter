state("Leap Year")
{
    float transitioning : 0xD7F450, 0xB0, 0x60, 0x2C4;
    int scene : 0xD6FF54;
    int dates : 0xD6FE98, 0xB18, 0x430, 0x0, 0x178; // counts down from 29 for each date collected
    double timer : 0xD7F450, 0xB0, 0x190, 0x50;
    byte464 dateArray : 0xB4D4E8, 0x0, 0x468, 0x168, 0xC00; // actually a true/false double array
}

startup
{
    settings.Add("Every room",  false, "Split on every room transition");

    settings.Add("Every date",  true, "Split on every date collected");

    settings.Add("Every 4th",  false, "Split on every 4 total dates collected (and also splits on 29 total)"); 
    settings.SetToolTip("Every 4th", "I.e. split on 4,8,12,16,20,24,28,29 total number of dates collected, regardless of order.");

    settings.Add("Specify dates", true, "Specify dates");
    for (int i = 0; i < 29; i++)
    {
        settings.Add(""+i, false, ""+(i+1), "Specify dates");
    }
}

start
{
    // Start when going from main menu scene to in-game scene. Also checks whether the dates is set to 29 to distinguish New Game from Continue.
    return old.scene == 2 && current.scene == 3 && current.dates == 29;
}

split
{
    if (settings["Every room"])
    {
        if (current.transitioning > 1 && old.transitioning < 1)
        {
            return true;
        }
    }

    if (current.dates != old.dates-1) //Don't waste time if date was not collected
    {
        return false;
    }

    if (settings["Every date"])
    {
        return true;
    }
    if (settings["Every 4th"])
    {
        if (current.dates == 0 || (29-current.dates) % 4 == 0)
        {
            return true;
        }
    }
    if (settings["Specify dates"])
    {
        for (int i = 0; i < 29; i++)
        {
            if (settings[""+i] && current.dateArray[7 + 16*i] > old.dateArray[7 + 16*i])
            {
                return true;
            }
        }
    }
    
    return false;
}

gameTime
{
	return TimeSpan.FromSeconds(current.timer);
}

isLoading
{
    return true;
}