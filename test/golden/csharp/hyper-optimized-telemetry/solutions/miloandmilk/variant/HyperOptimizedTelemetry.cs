public static class TelemetryBuffer
{
    public static byte[] ToBuffer(long reading)
    {
        byte prefix;
        byte[] bytes;
        byte[] buffer = new byte[9];

        if (reading > 4_294_967_295)
        {
            prefix = (byte)0xf8;
            bytes = BitConverter.GetBytes(reading);
        }
        else if (reading > 2_147_483_647)
        {
            prefix = (byte)0x4;
            bytes = BitConverter.GetBytes(reading);
        }
        else if (reading >= 65_535)
        {
            prefix = (byte)0xfc;
            bytes = BitConverter.GetBytes(reading);
        }
        else if (reading > -1)
        {
            prefix = (byte)0x2;
            bytes = BitConverter.GetBytes(reading);
        }
        else if (reading > -32_769)
        {
            prefix = (byte)0xFE;
            bytes = BitConverter.GetBytes((short)reading);
        }
        else if (reading > -2_147_483_649)
        {
            prefix = (byte)0xFC;
            bytes = BitConverter.GetBytes((int)reading);
        }
        else
        {
            prefix = (byte)0xf8;
            bytes = BitConverter.GetBytes(reading);
        }
        buffer[0] = prefix;
        bytes.CopyTo(buffer, 1);
        return buffer;
    }

    public static long FromBuffer(byte[] buffer)
    {
        var bytes = buffer.ToList().Skip(1).ToArray<byte>();
        return buffer[0] switch
        {
            0xF8 => BitConverter.ToInt64(bytes),
            0x04 => BitConverter.ToUInt32(bytes),
            0xFC => BitConverter.ToInt32(bytes),
            0x02 => BitConverter.ToUInt16(bytes),
            0xFE => BitConverter.ToInt16(bytes),
            _ => 0
        };
    }
}