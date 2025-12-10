import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { User, UserDocument } from "./user.schema";

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private readonly model: Model<User>) {}

  create(data: Partial<User>): Promise<UserDocument> {
    return this.model.create(data);
  }

  findByEmail(email: string) {
    return this.model.findOne({ email }).select("+passwordHash +refreshTokenHash").exec();
  }

  findById(id: string): Promise<UserDocument | null> {
    return this.model.findById(id).exec();
  }

  setRefreshHash(id: string, refreshHash?: string): Promise<UserDocument | null> {
    return this.model
      .findByIdAndUpdate(id, { refreshTokenHash: refreshHash }, { new: true })
      .exec();
  }
}
