module AssetHelper
  def asset_request_data
    {
      "uuid": "823737e4-bdc4-401a-b309-ef4c4d4f4733",
      "groupId": "contract-bdc4-401a",
      "title": "signable contract",
      "summary": "updated asset",
      "file": {
        "title": "secure MP4",
        "base64": "data:@file/pdf;base64,JVBERi0xLjQKJdPr6eEKMSAwIG9iago8PC9D..."
      },
      "content": {},
      "access": [
        {
          "uuid": "user@org1.example.com",
          "permissions": [
            {
              "action": "read",
              "name": "verified",
              "value": "true"
            }
          ]
        }
      ]
    }
  end

  def asset_response_data
    {
      title: "string",
      summary: "string",
      uuid: "string",
      txId: "string",
      groupId: "string",
      createdBy: "string",
      file: {
        title: "string",
        base64: "string",
        fileHash: "string",
        path: "string",
        fileValidated: true
      },
      content: {},
      access: [
        {
          uuid: "string",
          permissions: [
            {
              action: "string",
              name: "string",
              value: "string"
            }
          ]
        }
      ],
      createdAt: "2023-05-22T13:58:28.487Z",
      lastInteraction: {
        timestamp: "2023-05-22T13:58:28.487Z",
        fileModified: true,
        interactionFrom: "string"
      },
      events: [
        {
          txId: "string",
          value: {
            summary: "string",
            interaction: {
              timestamp: "2023-05-22T13:58:28.487Z",
              fileModified: true,
              interactionFrom: "string"
            }
          },
          action: "string"
        }
      ]
    }
  end

  def file_response_data
    {
      title: "string",
      base64: "string",
      fileHash: "string",
      path: "string",
      fileValidated: true
    }
  end

  def content_response_data
    {
      test_name: "new asset",
      test_value: "uberbverbveoyfubeou",
      test_access_date: "14-09-2009"
    }
  end
end
