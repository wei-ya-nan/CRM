package com.wyn.crm.service.impl;

import com.wyn.crm.entity.Contacts;
import com.wyn.crm.mapper.ContactsMapper;
import com.wyn.crm.service.api.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;



    public List<Contacts> getContactsForLikeName(String fullname) {
        return contactsMapper.queryContactsForLikeFullname(fullname);
    }
}
