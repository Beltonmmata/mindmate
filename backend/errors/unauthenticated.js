import { StatusCodes } from "http-status-codes";
import { CustomError } from "./custom-error.js";

export class UnauthenticatedError extends CustomError {
  constructor(message) {
    super(message);
    this.statusCode = StatusCodes.UNAUTHORIZED;
  }
}
