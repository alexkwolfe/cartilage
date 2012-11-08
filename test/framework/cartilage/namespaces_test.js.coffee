module "Cartilage.Namespaces"

test "should have view namespaces", ->
  views = {
    Foo: {
      fqn: 'Foo',
      Bar: {
        fqn: 'Foo.Bar',
        ShowView: Cartilage.Application.Views.Foo.Bar.ShowView
      }
    }
  }
  deepEqual(Cartilage.Application.Views, views)
