import {
  DynamoDBClient,
  GetItemCommand,
  PutItemCommand,
  UpdateItemCommand,
  DeleteItemCommand,
  QueryCommand,
  ScanCommand,
} from "@aws-sdk/client-dynamodb";
import { ZodSchema, ZodError } from "zod";

export class DynamoDBWrapper {
  private docClient: DynamoDBClient;

  constructor() {
    this.docClient = new DynamoDBClient({
      endpoint:
        process.env.NODE_ENV !== "production"
          ? "http://localhost:8000"
          : undefined,
      region: "us-east-1",
    });
  }

  private validateSchema<T>(schema: ZodSchema<T>, data: T): void {
    const result = schema.safeParse(data);
    if (!result.success) {
      throw new ZodError(result.error.errors);
    }
  }

  async getItem<T>(params: GetItemCommand["input"]): Promise<T | null> {
    try {
      const data = await this.docClient.send(new GetItemCommand(params));
      return (data.Item as T) || null;
    } catch (error) {
      console.error("Error getting item:", error);
      throw new Error("Error getting item");
    }
  }

  async putItem<T>(
    params: PutItemCommand["input"],
    schema: ZodSchema<T>
  ): Promise<void> {
    // this.validateSchema(schema, params.Item as T);
    try {
      await this.docClient.send(new PutItemCommand(params));
    } catch (error) {
      console.error("Error putting item:", error);
      throw new Error("Error putting item");
    }
  }

  async updateItem(params: UpdateItemCommand["input"]): Promise<void> {
    try {
      await this.docClient.send(new UpdateItemCommand(params));
    } catch (error) {
      console.error("Error updating item:", error);
      throw new Error("Error updating item");
    }
  }

  async deleteItem(params: DeleteItemCommand["input"]): Promise<void> {
    try {
      await this.docClient.send(new DeleteItemCommand(params));
    } catch (error) {
      console.error("Error deleting item:", error);
      throw new Error("Error deleting item");
    }
  }

  async query<T>(params: QueryCommand["input"]): Promise<T[]> {
    try {
      const data = await this.docClient.send(new QueryCommand(params));
      return data.Items as T[];
    } catch (error) {
      console.error("Error querying items:", error);
      throw new Error("Error querying items");
    }
  }

  async scan<T>(params: ScanCommand["input"]): Promise<T[]> {
    try {
      const data = await this.docClient.send(new ScanCommand(params));
      return data.Items as T[];
    } catch (error) {
      console.error("Error scanning items:", error);
      throw new Error("Error scanning items");
    }
  }
}
