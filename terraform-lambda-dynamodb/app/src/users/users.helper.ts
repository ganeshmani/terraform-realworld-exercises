import { AttributeValue } from "@aws-sdk/client-dynamodb";

// Helper function to convert User object to DynamoDB format
export const convertToDynamoDBItem = (
  item: any
): { [key: string]: AttributeValue } => {
  const result: { [key: string]: AttributeValue } = {};
  for (const [key, value] of Object.entries(item)) {
    if (typeof value === "string") {
      result[key] = { S: value };
    } else if (typeof value === "number") {
      result[key] = { N: value.toString() };
    } else if (Array.isArray(value)) {
      result[key] = { L: value.map((v) => ({ S: v.toString() })) };
    } else if (typeof value === "boolean") {
      result[key] = { BOOL: value };
    } else if (typeof value === "object" && value !== null) {
      result[key] = { M: convertToDynamoDBItem(value) };
    }
  }
  console.log("result", result);
  return result;
};
