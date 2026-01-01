  const String linkeserverName="http://192.168.1.101:8000";
  const String linkelogin = "$linkeserverName/api/client/login";
  const String linkeViewAppartment = "$linkeserverName/api/client/showAll";
  const String linkelogout= "$linkeserverName/api/client/logout";
  const String linkAddApartment="$linkeserverName/api/client/addApartment";
  const String linkeregister="$linkeserverName/api/client/register";
  const String linkecontractsbook="$linkeserverName/api/apartments/contractsbook";
  const String linkeViewApartmentStatus = "$linkeserverName/api/apartment/status";

  const String linkecontractsUpdate="$linkeserverName/api/apartment/updateBooking";
  const String linkemycontracts = "$linkeserverName/api/apartment/mycontracts";
  const String linkeViewmyAppartment = "$linkeserverName/api/client/showmyAll";
  const String linkeAddComment="$linkeserverName/api/apartments/Addcomments";
  String linkeviewComents(int apartmentId)=>"$linkeserverName/api/apartments/comments/$apartmentId";
  String linkeCanComment(int apartmentId, int tenantId) =>"$linkeserverName/api/apartments/can-comment/$apartmentId/$tenantId";
  const String linkefilter = "$linkeserverName/api/apartments/filter";
  String linkeViewcontractStatus(int apartmentId) => "$linkeserverName/api/apartments/viewApartmentStatus/$apartmentId";
  String linkeDeleteApartment(int apartmentId) => "$linkeserverName/api/apartments/delete/$apartmentId";
  const linkeviewall="$linkeserverName/api/client/showAll";
  String AcceptBooking(int contractID)=>"$linkeserverName/api/apartments/contracts/confirm/$contractID";
  String linkecontractsCancel = "$linkeserverName/api/apartments/contracts/cancel";
  String linkeApproveCancel(int id) => "$linkeserverName/api/apartments/contracts/cancel/approve/$id";
  String linkeRejectCancel(int id) => "$linkeserverName/api/apartments/contracts/cancel/reject/$id";
  String linkeApproveUpdate(int contractId) =>"$linkeserverName/api/contracts/approve-update/$contractId";
  String linkeRejectUpdate(int contractId) =>"$linkeserverName/api/contracts/reject-update/$contractId";
  String linkeViewMessages(int conversationId) =>"$linkeserverName/api/conversations/$conversationId/messages";
  const String linkCheckConversation = "$linkeserverName/api/conversations/check";
  const String linkCreateConversation = "$linkeserverName/api/conversations/create";
  String linkUserConversations(int clientId) =>
      "$linkeserverName/api/clients/$clientId/conversations";
  String linkeAddMessage(int? conversationId) {
    if (conversationId == null) {
      return "$linkeserverName/api/conversations/messages";
    }
    return "$linkeserverName/api/conversations/$conversationId/messages";
  }
