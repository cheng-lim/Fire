import 'package:fire_dev/interpreter/test/dummy_data.dart';
import 'package:fire_dev/interpreter/test/util/functions.dart';

class GetTest {
  static run() async {
    // Get a single document
    await expect(
      testTitle: 'Get a single document',
      expectedResponse: DummyData.london,
      query: 'cities.london.get();',
    );

    // Get multiple documents
    await expect(
      testTitle: 'Get multiple documents',
      expectedResponse: DummyData.tokyo_seattle,
      query: 'cities.[tokyo, seattle].get();',
    );

    // Get all documents
    await expect(
      testTitle: 'Get all documents',
      expectedResponse: DummyData.tokyo_seattle_london,
      query: 'cities.get();',
    );

    // Get single equal string condition
    await expect(
      testTitle: 'Get single equal string condition',
      expectedResponse: DummyData.london,
      query: "cities.where(country == 'uk').get();",
    );

    // Get single equal number condition
    await expect(
      testTitle: 'Get single equal number condition',
      expectedResponse: DummyData.seattle,
      query: "cities.where(population == 1500000).get();",
    );

    // Get single equal boolean condition
    await expect(
      testTitle: 'Get single equal boolean condition',
      expectedResponse: DummyData.seattle_london,
      query: "cities.where(has_lakes == true).get();",
    );

    // Get single equal decimal condition
    await expect(
      testTitle: 'Get single equal decimal condition',
      expectedResponse: DummyData.tokyo,
      query: "cities.where(birth_rate == 0.89).get();",
    );

    // Get single equal array condition;
    await expect(
      testTitle: 'Get single equal array condition',
      expectedResponse: DummyData.tokyo,
      query: "cities.where(neighbor_cities == [osaka, nagoya, kyoto]).get();",
    );

    // we don't support map yet due to pair declaration development is needed.
    //nested array is not supported too.

    // Get single unequal string condition
    await expect(
      testTitle: 'Get single unequal string condition',
      expectedResponse: DummyData.tokyo_seattle,
      query: "cities.where(country != 'uk').get();",
    );

    // Get single unequal number condition
    await expect(
      testTitle: 'Get single unequal number condition',
      expectedResponse: DummyData.tokyo_london,
      query: "cities.where(population != 1500000).get();",
    );

    // Get single unequal boolean condition
    await expect(
      testTitle: 'Get single unequal boolean condition',
      expectedResponse: DummyData.tokyo,
      query: "cities.where(has_lakes != true).get();",
    );

    // Get single unequal decimal condition
    await expect(
      testTitle: 'Get single unequal decimal condition',
      expectedResponse: DummyData.garry_rose,
      query: "students.where(weight != 100.33).get();",
    );

    // Get single greater or equal number condition
    await expect(
      testTitle: 'Get single greater or equal number condition',
      expectedResponse: DummyData.tokyo_london,
      query: "cities.where(population >= 2000000).get();",
    );

    // Get single greater or equal decimal condition
    await expect(
      testTitle: 'Get single greater or equal decimal condition',
      expectedResponse: DummyData.garry_rose,
      query: "students.where(weight >= 133.21).get();",
    );

    // Get single greater or equal string condition
    await expect(
      testTitle: 'Get single greater or equal string condition',
      expectedResponse: DummyData.seattle_london,
      query: "cities.where(country >= 'uk').get();",
    );

    // Get single less or equal number condition
    await expect(
      testTitle: 'Get single less or equal number condition',
      expectedResponse: DummyData.seattle,
      query: "cities.where(population <= 1500000).get();",
    );

    // Get single less or equal decimal condition
    await expect(
      testTitle: 'Get single less or equal decimal condition',
      expectedResponse: DummyData.garry_mary,
      query: "students.where(weight <= 133.21).get();",
    );

    // Get single less or equal string condition
    await expect(
      testTitle: 'Get single less or equal string condition',
      expectedResponse: DummyData.tokyo_seattle_london,
      query: "cities.where(country <= 'usa').get();",
    );

    // Get single greater number condition
    await expect(
      testTitle: 'Get single greater number condition',
      expectedResponse: DummyData.noValues,
      query: "cities.where(population > 123123123).get();",
    );

    // Get single greater decimal condition
    await expect(
      testTitle: 'Get single greater decimal condition',
      expectedResponse: DummyData.rose,
      query: "students.where(weight > 133.21).get();",
    );

    // Get single greater string condition
    await expect(
      testTitle: 'Get single greater string condition',
      expectedResponse: DummyData.seattle,
      query: "cities.where(country > 'uk').get();",
    );

    // Get single less number condition
    await expect(
      testTitle: 'Get single less number condition',
      expectedResponse: DummyData.tokyo_seattle,
      query: "cities.where(population < 123123122).get();",
    );

    // Get single less decimal condition
    await expect(
      testTitle: 'Get single less decimal condition',
      expectedResponse: DummyData.mary,
      query: "students.where(weight < 133.21).get();",
    );

    // Get single less string condition
    await expect(
      testTitle: 'Get single less string condition',
      expectedResponse: DummyData.tokyo,
      query: "cities.where(country < 'uk').get();",
    );

    // Get single where in array condition
    await expect(
      testTitle: 'Get single where in array condition',
      expectedResponse: DummyData.seattle_london,
      query: "cities.where(country in ['uk', 'usa']).get();",
    );

    // Get single contains string condition
    await expect(
      testTitle: 'Get single contains string condition',
      expectedResponse: DummyData.mary,
      query: "students.where('11' in grades).get();",
    );

    // Get single contains number condition
    await expect(
      testTitle: 'Get single contains number condition',
      expectedResponse: DummyData.mary_rose,
      query: "students.where(90 in grades).get();",
    );

    // Get single contains boolean condition
    await expect(
      testTitle: 'Get single contains boolean condition',
      expectedResponse: DummyData.garry_rose,
      query: "students.where(false in grades).get();",
    );

    // Get single contains decimal condition
    await expect(
      testTitle: 'Get single contains decimal condition',
      expectedResponse: DummyData.garry,
      query: "students.where(1.1 in grades).get();",
    );

    // Get single contains any array condition
    await expect(
      testTitle: 'Get single contains any array condition',
      expectedResponse: DummyData.gary_mary_rose,
      query: "students.where(['13', 1.1, true, 90] in grades).get();",
    );

    // Get single where not in array condition
    await expect(
      testTitle: 'Get single where not in array condition',
      expectedResponse: DummyData.tokyo_london,
      query: "cities.where(country out ['usa']).get();",
    );
  }
}
