import { DynamoDBWrapper } from "../lib/ddb-wrapper/index";
import { userSchema, User } from "./users.entities";
import { ulid } from "ulidx";
import { AttributeValue, PutItemCommandInput } from "@aws-sdk/client-dynamodb"; // Import AttributeValue
import { convertToDynamoDBItem } from "./users.helper";

const dynamoDB = new DynamoDBWrapper();

const createUser = async (payload: User) => {
  const existingUser = await getUserByEmail(payload.email);
  console.log("users", existingUser);
  if (existingUser) {
    throw new Error("User already exists");
  }

  const id = ulid();

  payload.userId = id;
  console.log("payload", payload);
  const params: PutItemCommandInput = {
    TableName: "Users",
    Item: convertToDynamoDBItem(payload), // Convert payload to DynamoDB format
  };
  await dynamoDB.putItem(params, userSchema);

  return {
    message: "User created successfully",
    user: payload,
  };
};

const getUser = async (userId: string) => {
  const params = {
    TableName: "Users",
    Key: {
      userId: { S: userId }, // Use AttributeValue type
    },
  };
  const users = await dynamoDB.getItem<User>(params);
  console.log(users);
  return users;
};

const getUserByEmail = async (email: string) => {
  const params = {
    TableName: "Users",
    IndexName: "email-index",
    KeyConditionExpression: "email = :email",
    ExpressionAttributeValues: {
      ":email": { S: email }, // Use AttributeValue type
    },
  };
  const users = await dynamoDB.query<User>(params);

  if (users.length === 0) {
    return null;
  }

  return users[0]; // Return the first user found
};

export { createUser, getUser };
