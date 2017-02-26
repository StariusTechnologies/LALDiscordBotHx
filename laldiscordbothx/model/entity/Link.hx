package laldiscordbothx.model.entity;

import laldiscordbothx.model.Entity.EntityProperties;

class Link extends Entity {
    public static var properties: EntityProperties = {
        tableName: 'link',
        tableColumns: [
            {
                name: 'id',
                mappedBy: 'id',
                primary: true
            },
            {
                name: 'name',
                mappedBy: 'name',
                primary: false
            },
            {
                name: 'content',
                mappedBy: 'content',
                primary: false
            }
        ]
    };

    public var id: Int;
    public var name: String;
    public var content: String;
}
