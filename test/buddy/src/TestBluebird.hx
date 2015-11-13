import buddy.BuddySuite;
import js.npm.Bluebird;
using buddy.Should;

class TestBluebird extends BuddySuite {
    public function new() {

        describe("Testing Bluebird", function () {
            it("Allows chaining after a '* -> Void' function", function (done) {
                var p = new Bluebird(function (resolve, reject) {
                    resolve("first value");
                }).then(function (firstValue) {
                    firstValue.should.be("first value");
                }).then(function () {
                    done();
                });
            });
        });
    }
}