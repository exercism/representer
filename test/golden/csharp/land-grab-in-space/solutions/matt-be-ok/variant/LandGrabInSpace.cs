public struct Coord
{
    public Coord(ushort x, ushort y)
    {
        X = x;
        Y = y;
    }

    public ushort X { get; }
    public ushort Y { get; }
}

public struct Plot
{
    public Coord coord1 { get; }
    public Coord coord2 { get; }
    public Coord coord3 { get; }
    public Coord coord4 { get; }
    
    public Plot(Coord cord1, Coord cord2, Coord cord3, Coord cord4)
    {
        coord1 = cord1;
        coord2 = cord2;
        coord3 = cord3;
        coord4 = cord4;
    }
}

public class ClaimsHandler
{
    private List<Plot> registeredClaims = new List<Plot>();
    
    private Plot claimWithLongestSide;
    private ushort longestSide = 0;
    
    public void StakeClaim(Plot plot)
    {
        registeredClaims.Add(plot);

        ushort sidelenghtX = (ushort)Math.Abs(plot.coord2.X - plot.coord1.X);
        ushort sidelenghtY = (ushort)Math.Abs(plot.coord3.Y - plot.coord1.Y);

        if(sidelenghtX >= longestSide)
        {
            longestSide = sidelenghtX;
            claimWithLongestSide = plot;
        }
        
        if (sidelenghtY > longestSide)
        {
            longestSide = sidelenghtY;
            claimWithLongestSide = plot;
        }
    }    

    public bool IsClaimStaked(Plot plot)
    {
        foreach(Plot claim in registeredClaims)
            if (plot.Equals(claim))
                return true;

        return false;                
    }

    public bool IsLastClaim(Plot plot) => plot.Equals(registeredClaims[registeredClaims.Count - 1]);

    public Plot GetClaimWithLongestSide() => claimWithLongestSide;
}
