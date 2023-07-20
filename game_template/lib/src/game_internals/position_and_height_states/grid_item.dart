enum GridItem {
  horizontalRoad,
  verticalRoad,
  intersectionRoad,
  building,
  boundary;

  bool isBuilding() => this == building;
  bool isRoad() =>
      this == horizontalRoad ||
      this == verticalRoad ||
      this == intersectionRoad;
}
