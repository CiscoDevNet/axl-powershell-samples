$certCallBack=@'
   using System.Net;
   using System.Security.Cryptography.X509Certificates;
   public class TrustAllPolicy : ICertificatePolicy {
      public bool CheckValidationResult(
         ServicePoint sPoint,
         X509Certificate cert,
         WebRequest wRequest,
         int certProb) { return true; }
   }
'@
Add-Type $certCallBack
[System.Net.ServicePointManager]::CertificatePolicy = new-object TrustAllPolicy