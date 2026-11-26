using System;
using System.Collections.Generic;

public class Authenticator
{
    // TODO: Implement the Authenticator.Admin property
    public Identity Admin { get
    {
		return new Identity()
		{
			Email = "admin@ex.ism",
			FacialFeatures = new FacialFeatures()
			{
				EyeColor = "green",
				PhiltrumWidth = (decimal)0.9
			},
			NameAndAddress = new List<string>()
			{
				"Chanakya", 
				"Mumbai",
				"India"
			}
		};
    }}

    // TODO: Implement the Authenticator.Developers property
   public IDictionary<string, Identity> Developers { get
	{
		var bertrand= new Identity()
		{
			Email = "bert@ex.ism",
			FacialFeatures = new FacialFeatures()
			{
				EyeColor = "blue",
				PhiltrumWidth = (decimal)0.8
			},
			NameAndAddress = new List<string>()
			{
				"Bertrand", 
				"Paris", 
				"France"
			}
		};
		var anders= new Identity()
		{
			Email = "anders@ex.ism",
			FacialFeatures = new FacialFeatures()
			{
				EyeColor = "brown",
				PhiltrumWidth = (decimal)0.85
			},
			NameAndAddress = new List<string>()
			{
				"Anders", 
				"Redmond",
				"USA"
			}
		};
		var developers = new Dictionary<string, Identity>();
		developers.Add("Bertrand", bertrand);		
		developers.Add("Anders", anders);
		
		return developers;

	}}
}

//**** please do not modify the FacialFeatures class ****
public class FacialFeatures
{
    public string EyeColor { get; set; }
    public decimal PhiltrumWidth { get; set; }
}

//**** please do not modify the Identity class ****
public class Identity
{
    public string Email { get; set; }
    public FacialFeatures FacialFeatures { get; set; }
    public IList<string> NameAndAddress { get; set; }
}
