using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace NoDB
{
    [ServiceContract]
    public interface IService1
    {
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Login", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        LoginResponse LoginSrv(LoginRequest usr);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Send", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        void SendSrv(SendRequest msg);

        [OperationContract]
        [WebGet(UriTemplate = "Messages/{id}", ResponseFormat = WebMessageFormat.Json)]
        List<Message> GetMessages(int id);
    }

    [DataContract]
    public class LoginResponse
    {
        [DataMember]
        public bool isAuth { get; set; }
    }
    [DataContract]
    public class LoginRequest
    {
        [DataMember]
        public string Username { get; set; }
        [DataMember]
        public string Password { get; set; }
    }
    [DataContract]
    public class SendRequest
    {
        [DataMember]
        public string Username { get; set; }
        [DataMember]
        public string Message { get; set; }
    }
    [DataContract]
    public class Message
    {
        [DataMember]
        public string Username { get; set; }
        [DataMember]
        public string Text { get; set; }
        [DataMember]
        public DateTime DateTime { get; set; }
    }
}
