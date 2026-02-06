import { IsString, IsNotEmpty } from "class-validator";

export class UpdateCommentDto {
  @IsString()
  @IsNotEmpty()
  declare content: string;
}
