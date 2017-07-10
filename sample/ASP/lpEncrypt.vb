Imports Newtonsoft.Json.Linq
Imports System.Security.Cryptography
Imports System.IO
Imports System.Text
Imports System.Security.Cryptography.X509Certificates
Imports System.Net
Imports Newtonsoft.Json

Public Class lpEncrypt
    Private fpkey As String
    Private dataJson = New JObject

    Const LP_LIMIT_BYTE As Integer = 64
    Const LP_URL As String = "http://service.linkprice.com/lppurchase_new.php"

    Public Sub New(pemPath As String)
        fpkey = pemPath
    End Sub

    Public Sub setJson(key, value)
        dataJson.Add(key, value)
    End Sub

    Public Function encrypt()
        Dim begin As String = "-----BEGIN PUBLIC KEY-----"
        Dim endKey As String = "-----END PUBLIC KEY-----"
        Dim resStr As String = ""
        Dim encodeData As String = ""

        Dim readAll = File.ReadAllText(fpkey).Trim()
        readAll = readAll.Replace(begin, "").Replace(endKey, "")
        Dim key = Convert.FromBase64String(readAll)

        Dim RSA As New RSACryptoServiceProvider()

        RSA = decodeX509publickey(key)

        Dim jsonStr As String = JsonConvert.SerializeObject(dataJson)
        Dim cutData As String

        Dim cnt As Integer = jsonStr.ToString().Trim().Length / LP_LIMIT_BYTE

        Try
            For i As Integer = 0 To cnt - 1
                If jsonStr.Length < 64 Then
                    cutData = jsonStr.Substring(LP_LIMIT_BYTE * i, jsonStr.Length)
                ElseIf i = cnt - 1 Then
                    cutData = jsonStr.Substring(LP_LIMIT_BYTE * i, jsonStr.Length - LP_LIMIT_BYTE * i)
                Else
                    cutData = jsonStr.Substring(LP_LIMIT_BYTE * i, LP_LIMIT_BYTE * (i + 1))
                End If

                Dim strByte = System.Text.Encoding.UTF8.GetBytes(cutData)
                Dim encryptedData = RSA.Encrypt(strByte, False)
                resStr &= Convert.ToBase64String(encryptedData) + "*|LINKPRICE|*"
            Next

            If resStr IsNot "" Then
                encodeData = WebUtility.UrlEncode(Convert.ToBase64String(Encoding.UTF8.GetBytes(resStr)))
            End If

            encrypt = encodeData
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Function decodeX509publickey(x509 As Byte())
        Dim SeqOID() As Byte = {&H30, &HD, &H6, &H9, &H2A, &H86, &H48, &H86, &HF7, &HD, &H1, &H1, &H1, &H5, &H0}
        Dim seq(15) As Byte

        Dim mem As New MemoryStream(x509)
        Dim binr As New BinaryReader(mem)
        Dim bt As Byte = 0
        Dim twobytes As UShort = 0

        Try
            twobytes = binr.ReadUInt16()
            If twobytes = &H8130 Then
                binr.ReadByte()
            ElseIf twobytes = &H8230 Then
                binr.ReadInt16()
            Else
                Return Nothing
            End If

            seq = binr.ReadBytes(15)
            If (Not seq.SequenceEqual(SeqOID)) Then
                Return Nothing
            End If

            twobytes = binr.ReadUInt16()
            If twobytes = &H8103 Then
                binr.ReadByte()
            ElseIf twobytes = &H8203 Then
                binr.ReadInt16()
            Else
                Return Nothing
            End If

            bt = binr.ReadByte()
            If bt <> &H0 Then
                Return Nothing
            End If

            twobytes = binr.ReadUInt16()
            If twobytes = &H8130 Then
                binr.ReadByte()
            ElseIf twobytes = &H8230 Then
                binr.ReadInt16()
            Else
                Return Nothing
            End If

            twobytes = binr.ReadUInt16()
            Dim lowbyte As Byte = &H0
            Dim highbyte As Byte = &H0

            If twobytes = &H8102 Then
                lowbyte = binr.ReadByte()
            ElseIf twobytes = &H8202 Then
                highbyte = binr.ReadByte()
                lowbyte = binr.ReadByte()
            Else
                Return Nothing
            End If

            Dim modint() As Byte = {lowbyte, highbyte, &H0, &H0}
            Dim modsize As Integer = BitConverter.ToInt32(modint, 0)

            Dim firstbyte As Byte = binr.ReadByte()
            binr.BaseStream.Seek(-1, SeekOrigin.Current)

            If firstbyte = &H0 Then
                binr.ReadByte()
                modsize -= 1
            End If

            Dim modulus() As Byte = binr.ReadBytes(modsize)

            If binr.ReadByte() <> &H2 Then
                Return Nothing
            End If

            Dim expbytes As Integer = binr.ReadByte()
            Dim exponent() As Byte = binr.ReadBytes(expbytes)

            Dim Rsa As New RSACryptoServiceProvider()
            Dim RsakeyInfo As New RSAParameters()
            RsakeyInfo.Modulus = modulus
            RsakeyInfo.Exponent = exponent

            Rsa.ImportParameters(RsakeyInfo)

            decodeX509publickey = Rsa

        Catch ex As Exception
            Return Nothing
        End Try

    End Function

    Public Sub submit()
        Dim ev = encrypt()
        Dim url = LP_URL + "?ev=" + ev

        Dim request As WebRequest = WebRequest.Create(url)
        Dim response As WebResponse = request.GetResponse()
        Dim resStream As Stream = response.GetResponseStream()

    End Sub
End Class
