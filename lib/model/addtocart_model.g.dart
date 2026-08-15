

part of 'addtocart_model.dart';



class AddtocartModelAdapter extends TypeAdapter<AddtocartModel> {
  @override
  final int typeId = 1;

  @override
  AddtocartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddtocartModel(
      image: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as int,
      quantity: fields[3] as int,
      size: fields[4] as String,
      addons: (fields[5] as List?)?.cast<AddonModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, AddtocartModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.addons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddtocartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
