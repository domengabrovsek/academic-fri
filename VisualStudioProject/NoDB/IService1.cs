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
        [WebInvoke(UriTemplate = "Login/{username}/{password}", ResponseFormat = WebMessageFormat.Json)]
        bool Login(string username, string password);

        [OperationContract]
        [WebInvoke(UriTemplate = "Send/{username}/{message}", ResponseFormat = WebMessageFormat.Json)]
        void Send(string username, string message);

        [OperationContract]
        [WebGet(UriTemplate = "Messages/{id}", ResponseFormat = WebMessageFormat.Json)]
        List<Message> GetMessages(int id);
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
