import { IsString, IsNotEmpty, IsOptional, IsMongoId } from "class-validator";

export class CreateCommentDto {
  @IsString()
  @IsNotEmpty()
  declare content: string;

  @IsMongoId()
  @IsOptional()
  parentId?: string;
}
