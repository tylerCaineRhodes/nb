
rg
' !theme toy
' !theme vibrant
' !theme crt-green
' !theme crt-amber

allow_mixing

title Example Artie Relationships

class Artie {
+ reviewAdBlock(ad_block): void
+ analyze_ad_block(ad_block): analysis (JSON)

.. attrs..
- ad_block
}

object ReviewArtieAssignedAdBlockJob

note left of ReviewArtieAssignedAdBlockJob: Cron job which assigns and reviews ad blocks with "ArtieUser"

rectangle AssignmentService
rectangle ReverseMirrorService


ReviewArtieAssignedAdBlockJob -up-> AssignmentService
ReviewArtieAssignedAdBlockJob -up-> ReverseMirrorService



rectangle AdBlockWordService
rectangle FinishAdBlockService

Artie --> AdBlockWordService: (ad_block)
Artie --> FinishAdBlockService: (ad_block)


object ArtieUser {
email: "artie@magellan.ai",
password: "password",
roles: ["upworker"]
}


ArtieUser .left. ReviewArtieAssignedAdBlockJob
ArtieUser .left. Artie
ReviewArtieAssignedAdBlockJob...Artie


class Parent
class ChildA
class ChildB

Parent <|-left- ChildA: sublass
Parent <|-left- ChildB: subclass

class House
class Lawn
class Door
class Window


House "1" -- "1...*" Door: Relation
House "1" -- "1...*" Window: Relation
Lawn -right- House


package Database <<Database>> {
  class SomeDatabaseClass
  }
  package SomeCloud <<Cloud>>{
  }
  package SomeFolder <<Folder>>{
  }
  package SomeNode <<Node>>{
  }

  database postgres

  rectangle Service1
  storage SomeStorageThing

  component [some entity] as outside_entity

  json JsonDetails {
  "color": "blue",
  "is_cool": true
  }


  database clickhouse {
    ' [some inside entity] as inside_entity
      
        json InternalJsonDetails {
          "color": "red",
            "is_cool": false
              }
              }

              outside_entity --> InternalJsonDetails
              postgres --> InternalJsonDetails

              undefined_service -- another_undefined_service

              Service1 -left- SomeStorageThing

              Service1 <-down- undefined_service
              Service1 <-down- another_undefined_service


              SomeStorageThing --> JsonDetails : "Record Shape"

              @enduml

