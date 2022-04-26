package com.wyn.crm.web.controller;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Activity;
import com.wyn.crm.entity.ActivityRemark;
import com.wyn.crm.entity.User;
import com.wyn.crm.service.api.ActivityRemarkService;
import com.wyn.crm.service.api.ActivityService;
import com.wyn.crm.service.api.UserService;
import com.wyn.crm.utils.*;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/17
 */
@Controller

public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("contacts/index.html")
    public String contactsIndex(Model model) {

        return "workbench/contacts/index";
    }

    @RequestMapping("activity/index.html")
    public String activityIndex(Model model) {
        List<User> users = userService.getAllUsers();
        /*List<Activity> users = activityService.getActivityAll();*/

        model.addAttribute("users", users);
        return "workbench/activity/index";
    }

    @ResponseBody
    @RequestMapping("activity/add.json")
    public ResultEntity<String> activityAdd(Activity activity, HttpSession session) {


        User user = (User) session.getAttribute("user");
        if (user == null) {
            activity.setId(CrmUtil.getUUId());
        }
        activity.setId(CrmUtil.getUUId());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());

        int result = activityService.addActivity(activity);

        if (result < 0 || result == 0) {
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("activity/queryCondition/page.json")
    public ResultEntity<PageInfo<Activity>>
    queryKeywordByConditionPage(@RequestParam(value = "keyword", defaultValue = "") String keyword,
                                @RequestParam(value = "pageNum",
                                        defaultValue = "1") Integer pageNum,
                                @RequestParam(value = "pageSize",
                                        defaultValue = "5") Integer pageSize,
                                @RequestParam(value = "owner", defaultValue = "") String owner,
                                @RequestParam(value = "startDate", defaultValue = "") String startDate,
                                @RequestParam(value = "endDate", defaultValue = "") String endDate) {

        System.out.println(keyword);
        PageInfo<Activity> page = activityService.getActivityPage(keyword, pageNum, pageSize, owner, startDate,
                endDate);

        List<Activity> list = page.getList();

        return ResultEntity.successWithData(page);
    }


    @ResponseBody
    @RequestMapping("activity/id/delete.json")
    public ResultEntity<Object> deleteActivityIds(@RequestParam("ids") List<String> ids) {
        activityService.deleteActivity(ids);
        System.out.println(ids.toString());
        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("activity/id/queryOne.json")
    public ResultEntity<Activity> queryOneActivityOne(@RequestParam("id") String id) {
        Activity activity = activityService.getActivityOne(id);
        return ResultEntity.successWithData(activity);
    }

    @ResponseBody
    @RequestMapping("activity/id/update.json")
    public ResultEntity<String> updateActivity(Activity activity, HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");
            activity.setEditBy(user.getId());
            activity.setEditTime(DateUtils.formateDate(new Date()));


            activityService.updateActivity(activity);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData();
    }


    @ResponseBody
    @PostMapping("import/activity/xls.json")
    public ResultEntity<Object> importActivityJson(MultipartFile file, HttpSession session) {
        User user = (User) session.getAttribute("user");
        try {
            InputStream is = file.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(is);
            //根据wb获取HSSFSheet对象，封装了一页的所有信息
            HSSFSheet sheet = wb.getSheetAt(0);//页的下标，下标从0开始，依次增加
            //根据sheet获取HSSFRow对象，封装了一行的所有信息
            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<Activity>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {//sheet.getLastRowNum()：最后一行的下标
                row = sheet.getRow(i);//行的下标，下标从0开始，依次增加
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getName());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                activity.setCreateBy(user.getId());

                for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum():最后一列的下标+1
                    //根据row获取HSSFCell对象，封装了一列的所有信息
                    cell = row.getCell(j);//列的下标，下标从0开始，依次增加

                    //获取列中的数据
                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    if (j == 0) {
                        activity.setName(cellValue);
                    } else if (j == 1) {
                        activity.setStartDate(cellValue);
                    } else if (j == 2) {
                        activity.setEndDate(cellValue);
                    } else if (j == 3) {
                        activity.setCost(cellValue);
                    } else if (j == 4) {
                        activity.setDescription(cellValue);
                    }
                }

                //每一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }
            activityService.addActivityList(activityList);

        } catch (IOException e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }


        return ResultEntity.successWithData();
    }


    @RequestMapping("activity/exportAll.html")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        List<Activity> activityAll = activityService.getActivityAll();

        //创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        if (activityAll != null && activityAll.size() > 0) {
            Activity activity = null;
            for (int i = 0; i < activityAll.size(); i++) {
                activity = activityAll.get(i);

                //每遍历出一个activity，生成一行
                row = sheet.createRow(i + 1);
                //每一行创建11列，每一列的数据从activity中获取
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");
        OutputStream out = response.getOutputStream();
        wb.write(out);

        wb.close();
        out.flush();

    }


    @RequestMapping("/activity/exportMore.html")
    public void exportMore(HttpServletResponse response, @RequestParam("ids") List<String> ids) throws IOException {

        //创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");
//
        if (ids != null && ids.size() > 0) {
            Activity activity = null;
            for (int i = 0; i < ids.size(); i++) {
                System.out.println(ids.get(i));
                activity = activityService.getActivityOne(ids.get(i));
//                activity=ids.get(i);
                System.out.println(activity.toString());

                //每遍历出一个activity，生成一行
                row = sheet.createRow(i + 1);
                //每一行创建11列，每一列的数据从activity中获取
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");
        OutputStream out = response.getOutputStream();
        wb.write(out);

        wb.close();
        out.flush();

        System.out.println(ids.size());

    }


    @RequestMapping("/activity/detail.html")
    public String detail(String id, Model model) {
        Activity activityOne = activityService.getActivityOneById(id);
        List<ActivityRemark> oneById = activityRemarkService.getOneById(id);

        System.out.println("activityOne:" + activityOne);
        System.out.println("oneById:" + oneById);

        model.addAttribute("activity", activityOne);
        model.addAttribute("activityRemark", oneById);
        return "workbench/activity/detail";
    }


}
