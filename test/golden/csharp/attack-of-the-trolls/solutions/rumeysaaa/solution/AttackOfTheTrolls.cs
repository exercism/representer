

using System;

static class Permissions
{
    public static Permission Default(AccountType accountType)
    {
        switch (accountType)
        {
            case AccountType.Guest:
                return Permission.Read;
            case AccountType.User:
                return Permission.Write | Permission.Read;
            case AccountType.Moderator:
                return Permission.Write | Permission.Read | Permission.Delete;
            default:
                return Permission.None;

        }
    }

    public static Permission Grant(Permission current, Permission grant)
    {
        Permission newYetki = current | grant;
       
        return newYetki;
    }

    public static Permission Revoke(Permission current, Permission revoke)
    {
        Permission removeYetki= current & ~revoke;
        return removeYetki;
    }

    public static bool Check(Permission current, Permission check) =>current.HasFlag(check);
  


}
enum AccountType
{
    Guest,
    User,
    Moderator
}
[Flags]
enum Permission
{
    None = 0,
    Read = 1,
    Write = 2,
    Delete = 4,
    All = 7
}