class TrackingData {
  late int trackStatus;
  late int shipmentStatus;
  late List<ShipmentTrack> shipmentTrack;
  late List<ShipmentTrackActivity> shipmentTrackActivities;
  late String trackUrl;
  late String etd;
  late QcResponse qcResponse;

  TrackingData.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      Map<String, dynamic> trackingData = json['tracking_data'];
      trackStatus = json['track_status'] ?? 0;
      shipmentStatus = json['shipment_status'] ?? 0;
      trackUrl = json['track_url'] ?? "h";
      etd = json['etd'] ?? "yy";
      qcResponse = QcResponse.fromJson(json['qc_response'] ?? {});

      shipmentTrack = (json['tracking_data']['shipment_track'] as List? ?? [])
          .map((e) => ShipmentTrack.fromJson(e as Map<String, dynamic>))
          .toList();

      shipmentTrackActivities =
          (json['tracking_data']['shipment_track_activities'] as List? ?? [])
              .map((e) => ShipmentTrackActivity.fromJson(e as Map<String, dynamic>))
              .toList();
    } else {
      // Set default values if json is null
      trackStatus = 0;
      shipmentStatus = 0;
      trackUrl = "h";
      etd = "yy";
      qcResponse = QcResponse.fromJson({});
      shipmentTrack = [];
      shipmentTrackActivities = [];
    }
  }

}

class ShipmentTrack {
  late int id;
  late String awbCode;
  late int courierCompanyId;
  late int shipmentId;
  late int orderId;
  late String pickupDate;
  late String? deliveredDate;
  late String weight;
  late int packages;
  late String currentStatus;
  late String deliveredTo;
  late String destination;
  late String consigneeName;
  late String origin;
  late dynamic courierAgentDetails;
  late String courierName;
  late String edd;
  late String pod;
  late String podStatus;
  late String rtoDeliveredDate;

  ShipmentTrack.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 09;
    awbCode = json['awb_code'] ?? "jj";
    courierCompanyId = json['courier_company_id'] ?? 09;
    shipmentId = json['shipment_id'] ?? 8;
    orderId = json['order_id'] ?? 7;
    pickupDate = json['pickup_date'] ?? "hj";
    deliveredDate = json['delivered_date'] ?? "hj";
    weight = json['weight'] ?? "12Kh";
    packages = json['packages'] ?? 9;
    currentStatus = json['current_status'] ?? "jj";
    deliveredTo = json['delivered_to'] ?? "hj";
    destination = json['destination'] ?? "hyh";
    consigneeName = json['consignee_name'] ?? "hh";
    origin = json['origin'] ?? "jj";
    courierAgentDetails = json['courier_agent_details'] ?? "jj";
    courierName = json['courier_name'] ?? 'jj';
    edd = json['edd'] ?? "j";
    pod = json['pod'] ?? "hj";
    podStatus = json['pod_status'] ?? "jj";
    rtoDeliveredDate = json['rto_delivered_date'] ?? "n";
  }
}

class ShipmentTrackActivity {
  late String date;
  late String status;
  late String activity;
  late String location;
  late int srStatus;
  late String srStatusLabel;

  ShipmentTrackActivity.fromJson(Map<String, dynamic> json) {
    date = json['date']  ?? "u";
    status = json['status'] ?? "u";
    activity = json['activity'] ?? "u";
    location = json['location'] ?? "h";
    srStatus = json['sr-status'] ?? 9;
    srStatusLabel = json['sr-status-label'] ?? "hf";
  }
}

class QcResponse {
  late String qcImage;
  late String qcFailedReason;

  QcResponse.fromJson(Map<String, dynamic> json) {
    qcImage = json['qc_image'] ?? "u";
    qcFailedReason = json['qc_failed_reason'] ?? "juj";
  }
}
