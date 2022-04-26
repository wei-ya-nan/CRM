package com.wyn.test;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Activity;
import com.wyn.crm.entity.User;
import com.wyn.crm.mapper.ActivityMapper;
import com.wyn.crm.mapper.UserMapper;
import com.wyn.crm.service.api.UserService;
import com.wyn.crm.service.impl.UserServiceImpl;
import com.wyn.crm.utils.CrmUtil;
import org.apache.ibatis.logging.stdout.StdOutImpl;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.SystemProfileValueSource;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:applicationContext-datasource" +
        ".xml"})
public class TestUsers {

    @Autowired
    UserMapper userMapper;

    @Autowired
    ActivityMapper activityMapper;

    @Test
    public void test01() {
        System.out.println(userMapper);
        List<User> users = userMapper.selectByExample(null);
        System.out.println(users.toString());

    }

    @Test
    public void test02(){
        String s = CrmUtil.md5("123");
        System.out.println(s);
    }

    @Test
    public void test03(){
        PageHelper.startPage(0, 2);

        List<Activity> list = activityMapper.selectByExample(null);
//        for (Activity a: list) {
//            System.out.println(a.getName());
//            System.out.println(a.getId());
//        }

//        System.out.println(list.toString());
        PageInfo<Activity> activityPageInfo = new PageInfo<Activity>(list, 5);
        Activity activity = activityPageInfo.getList().get(0);
        System.out.println(activity.getId());
        System.out.println(activityPageInfo);
    }

    @Test
    public void test04(){
        Activity activity = activityMapper.selectByPrimaryKey("1c47c192fc734c9fb90cfe534c5868d7");
        System.out.println(activity.toString());
    }

    @Test
    public void test05(){
        Activity activity = new Activity();
        activityMapper.updateByPrimaryKeySelective(null);

    }

    @Test
    public void test06(){


    }



}
