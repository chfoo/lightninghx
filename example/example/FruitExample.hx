package example;

import haxe.io.Bytes;
import lightninghx.EnvironmentFlags;
import lightninghx.Lightning;


class FruitExample {
    public static function main() {
        var environment = Lightning.environment();
        environment.setMapSize(2147483647);
        environment.open("example_fruit_db/");

        var transaction = environment.beginTransaction();
        var database = transaction.openDatabase();

        database.put(Bytes.ofString("apple"), Bytes.ofString("red"));
        database.put(Bytes.ofString("banana"), Bytes.ofString("yellow"));

        transaction.commit();

        transaction = environment.beginTransaction(EnvironmentFlags.ReadOnly);
        database = database.reuse(transaction);

        var appleColor = database.get(Bytes.ofString("apple")).toString();

        transaction.reset();

        trace('The color of an apple is $appleColor.');

        transaction.renew();

        var bananaColor = database.get(Bytes.ofString("banana")).toString();

        transaction.abort();

        trace('The color of a banana is $bananaColor.');

        environment.close();
    }
}
