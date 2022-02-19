--- @class UserEntity
local UserEntity = class('UserEntity')

function UserEntity:initialize(params)
    --- @type UserEntityPlain
    self.data = {
        id = params.id,
        name = params.name,
        photo = params.photo,
        photo_url = params.photo_url,
        lang = params.lang,
    }
end

function UserEntity:get_plain_data()
    return self.data
end

return UserEntity
